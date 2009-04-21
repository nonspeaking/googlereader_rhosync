class GoogleReaderItems < SourceAdapter
  
  include RestAPIHelpers

  def query
    log "GoogleReader query"
    require "rest_client"
    
    action_view=ActionView::Base.new()
    
    @result=[]
    
    if @source.credential and !@source.credential.login.blank?
      log "GoogleReaderItems syncing for user - #{@source.credential.login}"
      
      authresponse=RestClient.post('https://www.google.com/accounts/ClientLogin', :service=>'reader', :Email=>@source.credential.login, :Passwd=>@source.credential.password, :source=>'rhosync')
      if authresponse=~/SID=(.*)/
        sid=$1
      else
        return
      end
      
      log "GoogleReaderItems authenticated"
      xml=XmlSimple.xml_in(RestClient.get("http://www.google.com/reader/atom/user/-/state/com.google/reading-list", {:Cookie=>"SID=#{sid}"}).to_s)
      log "GoogleReaderItems received #{xml["entry"].length} XML items"
      if xml["entry"]
        xml["entry"].each do |e|
          @result.push({
            "title"=>e["title"][0]["content"],
            "id"=>e["id"][0]["content"].gsub(/[^a-zA-Z0-9]+/, "-"),
            "read"=>e["category"].collect{|c|c["term"]}.any?{|t|t=~/^user\/[0-9]+\/state\/com\.google\/read$/}.to_s,
            "body"=>action_view.sanitize(get_body(e), :tags=>%w(p br a), :attributes=>%w(id href)),
            "created_at"=>e["published"].to_s,
            "timestamp"=>e["gr:crawl-timestamp-msec"].to_s,
            "gr_id"=>e["id"][0]["content"]
            })
        end
      end
    end
  end

  def sync
    if @result
      log "GoogleReader sync, with #{@result.length} results"
    else
      log "GoogleReader sync, ERROR @result nil"
      return
    end
        
    @result.each do |e|      
      id = e["id"]
      # log "GoogleReader sync, result #{e["id"]}: #{e["title"]}"
      # iterate over all possible values, if the value is not found we just pass "" in to rhosync
      
      %w(title read body created_at timestamp gr_id).each do |key|
        value = e[key] ? e[key] : ""
        add_triple(@source.id, id, key.gsub('-','_'), value, @source.current_user.id)
        # convert "-" to "_" because "-" is not valid in ruby variable names   
      end
    end
  end
  
  def update(name_value_list)
    log "GoogleReaderItems updated with name values #{name_value_list.inspect}"
    
    get_params(name_value_list)
    return unless @params["read"] && @params["id"]
    log "GoogleReaderItems got all params read:#{@params["read"]}, id:#{@params["id"]}"
    
    idov=ObjectValue.find_by_object_and_attrib(@params["id"], "gr_id")
    return unless idov
    log "GoogleReaderItems found gr_id object value (#{idov.value})"
    
    authresponse=RestClient.post('https://www.google.com/accounts/ClientLogin', :service=>'reader', :Email=>@source.credential.login, :Passwd=>@source.credential.password, :source=>'rhosync')
    if authresponse=~/SID=(.*)/
      sid=$1
    else
      return
    end
    
    log "GoogleReaderItems getting token"
    token=RestClient.get("http://www.google.com/reader/api/0/token?ck=#{Time.now().to_i}&client=rhosync", {:Cookie=>"SID=#{sid}"})
    unless token.length>0
      log "GoogleReaderItems failed to get token"
    end
    
    log "GoogleReaderItems got token: #{token}"
    
    res=RestClient.post("http://www.google.com/reader/api/0/edit-tag?client=rhosync", {:i=>idov.value, :a=>"user/-/state/com.google/read", :ac=>"edit", :T=>token}, {:Cookie=>"SID=#{sid}"})
    log "GoogleReaderItems result from marking read:'#{res}'"
    
  end
  
  private
  
  def get_body(e)
    if e["summary"]
      return e["summary"].first["content"]
    elsif e["content"]
      return e["content"]["content"]
    end
    
    return ""
  end

end