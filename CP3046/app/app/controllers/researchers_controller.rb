class ResearchersController < ApplicationController

  # GET /researchers
  # GET /researchers.xml
  def index
    respond_to do |format|
      format.html { # index.html.erb
#		@researchers = Researcher.paginate :page => params[:page], :order => 'updated_at DESC'
		@researchers = Researcher.search(params[:search_name], params[:page])
	  }
      format.xml  { 
		  @researchers = Researcher.all
		  render :xml => @researchers }

    end
  end

  # GET /researchers/1
  # GET /researchers/1.xml
  def show
    @researcher = Researcher.find(params[:id])
	if @researcher == logged_in_researcher
		respond_to do |format|
		  format.html { render :layout => 'account' } # show.html.erb
		  format.xml  { render :xml => @researcher }
		  format.rss  { render :layout => false }
		end
	else
		respond_to do |format|
		  format.html # show.html.erb
		  format.xml  { render :xml => @researcher }
		  format.rss  { render :layout => false }
		end
	end

  end
  
  # GET /researchers/1/account
  def account
    @researcher = Researcher.find(params[:id])
	
	# Only viewable by the logged in researcher
	if @researcher == logged_in_researcher
		respond_to do |format|
		  format.html { render :layout => 'account' } # account.html.erb
		  format.rss  { render :layout => false }
		end
	else
		respond_to do |format|
			format.html { redirect_to(researcher_path(@researcher), :alert => "You can't view another user's account.") }
			format.xml  { request_http_basic_authentication(request.fullpath) }
			format.rss  { request_http_basic_authentication(request.fullpath) }
		end
	end

  end
  
# GET /researchers/1/posts
	def posts
		@researcher = Researcher.find(params[:id])

		if @researcher == logged_in_researcher
			respond_to do |format|
				format.html { render :layout => 'account' } # posts.html.erb
			end
		else
			respond_to do |format|
				format.html # research.html.erb
			end
		end
	end

# GET /researchers/1/edit
	def edit
		@researcher = Researcher.find(params[:id])
		if logged_in_researcher == @researcher
			respond_to do |format|
				format.html { render :layout => 'account' } # edit.html.erb
			end
		else
			respond_to do |format|
				format.html { redirect_to(@researcher, :alert => "You can't edit another user's details.") }
			end
		end
	end
  
  # PUT /researchers/1
  # PUT /researchers/1.xml
  def update
    @researcher = Researcher.find(params[:id])
    # Only allow the user to change the details of the researcher, if the researcher is the current user.
  	if logged_in_researcher == @researcher
      respond_to do |format|
			
        if @researcher.update_attributes(params[:researcher])
          format.html { redirect_to(@researcher, :notice => 'Researcher was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @researcher.errors, :status => :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to(@researcher, :alert => "You can't update another user's details.") }
        format.xml  { request_http_basic_authentication(request.fullpath) }
      end
    end
  end
end
