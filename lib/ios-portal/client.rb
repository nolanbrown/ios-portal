require "rubygems"
require "mechanize"
require "highline/import"

module IOSPortal
  class Client
    attr_accessor :username, :password, :account
        
    # Creates a new API
    def initialize(options={})
      self.username = options[:username]
      self.password = options[:password]
      self.account = options[:account]
      
      @@agent = Mechanize.new
      @@agent.follow_meta_refresh = true
    end
    
    def profiles(options={})
      if _authenticate

        profiles = {}
        
        all = options.has_key?(:all) ? options[:all] : true
        
        if options[:development] or all
          profiles[:development] = development_provisioning_profiles
        end

        if options[:distribution] or all
          profiles[:distribution] = distribution_provisioning_profiles
        end
        return profiles
      end
    end
    
    def devices(options={})
      if _authenticate
        page = @@agent.get(IOSPortal::DEVICES_URL)
        #puts page.parser.xpath('/').to_html
        profile_devices = []

        devices = page.at("div[@class='nt_multi']")
        raise "No devices" unless devices
        
        
        hidden_name = ""
        checkbox_name = ""
        devices.at("tbody").children.each{|row|
            device = {}
            row.children.each{|column|
                case column['class']
                when "checkbox"
                  device[:id] = column.children[1]['value'].strip
                when "name"
                  device[:name] = column.children[1].text.strip
                when "id"
                  device[:udid] = column.text.strip
                end
            }
            
            profile_devices.push(device) if device.length > 0
            
        }
        return profile_devices
        
      end
    end
    
    private
    def provisioning_profiles(url)
        page = @@agent.get(url)
        table =  page.at("//table/tbody") 
        profiles = []
        return profiles unless table

        table.children.each{|tr|
            children = tr.children
            cert_key =  children[0].children[0]['value'].strip
            cert_name = children[2].content.strip
            app_id = children[4].content.strip
            editable = false 
            children[8].search("a").each{|link|  
                if link.inner_html == "Edit"
                    editable = true
                    break
                end
            }
            profiles.push({:name => cert_name, :id => cert_key, :app_id => app_id, :editable => editable })
        }
        return profiles
    end

    def development_provisioning_profiles
        provisioning_profiles(IOSPortal::DEV_PROVISIONING_PROFILE_URL)
    end

    def distribution_provisioning_profiles

        provisioning_profiles(IOSPortal::DIST_PROVISIONING_PROFILE_URL)

    end
    
    def _authenticate
      agent = Mechanize.new
      agent.follow_meta_refresh = true
        # Get login page
      page = @@agent.get(IOSPortal::LOGIN_URL)

      # Submit form to login
      login_form = page.forms.first
      login_form['theAccountName']=self.username
      login_form['theAccountPW']=self.password
      page = @@agent.submit(login_form)

      # Fail if it looks like we ended up back at a login page
      if page.form('appleConnectForm')
        return nil
      else
        select_form = page.form('saveTeamSelection')
        if select_form
          options = []
          selection = -1
          select_form.fields.first.options.each{|option|
            if self.account == option.text
              selection = options.length + 1
            end
            options.push([option.text,option.value])
            
          }
         
          if selection < 0
            options.each_index { |i|
              puts "#{i+1}. #{options[i][0]}"
            }

            selection =  ask "Enter the # for the account you wish to login to: "
            if selection.to_i > (options.length )
              error "Invalid selection"
              return nil
            end
          end
          team = options[selection.to_i - 1]
          select_form['memberDisplayId'] = team[1]
          page = @@agent.submit(select_form, select_form.buttons[1])
          return page
        else
          return page
        end
      end
    end
    
  end
end