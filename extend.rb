require "fnordmetric"

FnordMetric.namespace :myapp do
  hide_active_users


  timeseries_gauge :number_of_signups,
    :title => "Number of Signups",
    :series => [:via_twitter, :via_facebook, :other],
    :resolution => 1.minute

  widget 'TechStats', {
    :title => "Events Numbers",
    :type => :numbers,
    :width => 100,
    :gauges => [:number_of_signups],
    :offsets => [1,3,5,10],
    :autoupdate => 1
  }

  event :go do
    puts data
    if data[:ref] == 'twitter'
      incr :number_of_signups, :via_twitter,1
    elsif data[:ref] == 'facebook'
      incr :number_of_signups, :via_facebook,1
    else
      incr :number_of_signups, :other,1
    end
  end

  # echo '{"_type": "go","ref":"facebzz"}' | nc localhost 1337
  # https://github.com/paulasmuth/fnordmetric
end

FnordMetric.standalone