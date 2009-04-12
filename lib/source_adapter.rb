class SourceAdapter
  attr_accessor :client
  def initialize(source=nil,credential=nil)
    @source = source.nil? ? self : source
  end

  def login

  end

  def query
  end
  
  def sync
    if @result.entry_list.size>0 
      if @source.credential.nil?
        user_id='NULL'
      else
        user_id=@source.current_user.id
      end
      sql="INSERT INTO object_values(id,pending_id,source_id,object,attrib,value,user_id) VALUES"
      @result.entry_list.each do |x|      
        x.name_value_list.each do |y|
          unless y.value.blank?         
            ovid=ObjectValue.hash_from_data(y.name,x['id'],nil,@source.id,user_id,y.value,rand)
            pending_id = ObjectValue.hash_from_data(y.name,x['id'],nil,@source.id,user_id,y.value)          
            sql << "(" + ovid.to_s + "," + pending_id.to_s + "," + @source.id.to_s + ",'" + x['id'] + "','" + y.name + "','" + y.value + "'," + user_id.to_s + "),"
          end
        end
      end
      sql.chop!
      ActiveRecord::Base.connection.execute sql
    else
      p "No objects returned from query"
    end
  end

  def create(name_value_list)
  end

  def update(name_value_list)
  end

  def delete(name_value_list)
  end

  def logoff
  end
  
  def set_callback(notify_urL)
  end
end