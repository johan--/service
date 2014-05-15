class ManufacturersController < ApplicationController

	before_filter :check_auth
	before_filter :check_admin

	def index
		@manufacturers = Manufacturer.order("firms.id ASC")
		respond_to do |format|
			format.html
			format.json { render json: ManufacturerJdts.new(view_context) }
		end
	end

	def show
		@manufacturer = Manufacturer.find(params[:id])
		@mm = @manufacturer.machines.order("machines.id ASC")
		respond_to do |format|
			format.html
			format.json { render json: @manufacturer }
		end
	end

	def new
		@manufacturer = Manufacturer.new
	end

	def create
		@manufacturer = Manufacturer.new(params[:manufacturer])
		if @manufacturer.save
			flash[:notice] = "Successfully created manufacturer."
			redirect_to manufacturers_path
		else
			flash[:alert] = "Please correct errors and try again!"
			render :new
		end
	end

	def update
		@manufacturer = Manufacturer.find(params[:id])
		respond_to do |format|
			if @manufacturer.update_attributes(params[:manufacturer])
				flash[:notice] = "Successfully updated manufacturer."
				format.html { redirect_to(manufacturer_path, :id => @manufacturer.id) }
			else
				render('edit')
			end
	    end
	end

	def delete
		@manufacturer = Manufacturer.find(params[:id])
	end

	def destroy
		manufacturer = Manufacturer.find(params[:id]).destroy
		flash[:notice] = "Manufacturer permanently deleted !"
		redirect_to manufacturers_path
	end

	def edit
		@manufacturer = Manufacturer.find(params[:id])
	end 
end
