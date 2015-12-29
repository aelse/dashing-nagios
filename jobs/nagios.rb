SCHEDULER.every '30s' do
  require 'bundler/setup'
  require 'nagiosharder'

  environments = {
    prod: { url: 'http://my-prod-nagios/cgi-bin/nagios3/', username: 'nagios', password: 'nagios' },
    dev: { url: 'http://my-dev-nagios/cgi-bin/nagios3/', username: 'nagios', password: 'nagios' },
  }

  environments.each do |key, env|
    nag = NagiosHarder::Site.new(env[:url], env[:username], env[:password])
    unacked = nag.service_status(:host_status_types => [:all], :service_status_types => [:warning, :critical], :service_props => [:no_scheduled_downtime, :state_unacknowledged, :checks_enabled])

    critical_count = 0
    warning_count = 0
    unacked.each do |alert|
      if alert["status"].eql? "CRITICAL"
        critical_count += 1
      elsif alert["status"].eql? "WARNING"
        warning_count += 1
      end
    end
  
    # nagiosharder may not alert us to a problem querying nagios.
    # If no problems found check that we fetch service status and
    # expect to find more than 0 entries.
    error = false
    if critical_count == 0 and warning_count == 0
      if nag.service_status.length == 0
        error = true
      end
    end
  
    if error
      # Send an empty payload, which the widget treats as an error
      send_event('nagios-' + key.to_s, { })
    else
      send_event('nagios-' + key.to_s, { criticals: critical_count, warnings: warning_count })
    end
  end
end
