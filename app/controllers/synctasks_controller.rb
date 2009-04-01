class SynctasksController < ApplicationController
  # GET /synctasks
  # GET /synctasks.xml
  def index
    @synctasks = Synctask.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @synctasks }
    end
  end

  # GET /synctasks/1
  # GET /synctasks/1.xml
  def show
    @synctask = Synctask.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @synctask }
    end
  end

  # GET /synctasks/new
  # GET /synctasks/new.xml
  def new
    @synctask = Synctask.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @synctask }
    end
  end

  # GET /synctasks/1/edit
  def edit
    @synctask = Synctask.find(params[:id])
  end

  # POST /synctasks
  # POST /synctasks.xml
  def create
    @synctask = Synctask.new(params[:synctask])

    respond_to do |format|
      if @synctask.save
        flash[:notice] = 'Synctask was successfully created.'
        format.html { redirect_to(@synctask) }
        format.xml  { render :xml => @synctask, :status => :created, :location => @synctask }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @synctask.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /synctasks/1
  # PUT /synctasks/1.xml
  def update
    @synctask = Synctask.find(params[:id])

    respond_to do |format|
      if @synctask.update_attributes(params[:synctask])
        flash[:notice] = 'Synctask was successfully updated.'
        format.html { redirect_to(@synctask) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @synctask.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /synctasks/1
  # DELETE /synctasks/1.xml
  def destroy
    @synctask = Synctask.find(params[:id])
    @synctask.destroy

    respond_to do |format|
      format.html { redirect_to(synctasks_url) }
      format.xml  { head :ok }
    end
  end
end
