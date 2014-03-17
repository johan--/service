class ServiceEventsController < ApplicationController
	respond_to :html, :json

	def index
		@events = ServiceEvent.order("service_events.id DESC")
	end

	def show
		@event = ServiceEvent.find(params[:id])
	end

	def new
		@event = ServiceEvent.new

		respond_to do |format|
			format.html
			format.json { render json: Alarm.search(params[:search]) }
		end

	end

	def create
		@event = ServiceEvent.new(params[:event])
		@event.user_id = current_user.id
		# hc = hour counter
		@hc = HourCounter.find_by_machine_id(@event.machine_id)
		if @event.save
			if params[:alarms] != nil
				@event.alarms << Alarm.find(params[:alarms])
			end
			@hc.update_attributes(:machine_hours_age => @event.hour_counter)
			# ServiceEventNotifier.confirmation(@event, @machine).deliver
			# ServiceEventNotifier.notification(@event, @machine).deliver
			flash[:notice] = 'Event successfully registered!' 	
			redirect_to root_path
		else
			@machines = Machine.where(:machine_owner_id => current_user.firm_id)
			flash.now[:alert] = 'Please correct errors and try again!'
			render :new
		end
	end

	def confirmation
		@event_name = @event.event_name
	end

	def confirm_event
		@event = ServiceEvent.find(params[:id])
		if check_event_confirmation(@event) == true
			@event.confirmed
			flash[:notice] = 'Event is confirmed'
			redirect_to service_event_path(@event)
		else
			flash[:notice] = "Something went wrong"
		end
			
	end

	def edit
		@event = ServiceEvent.find(params[:id])
		@machines = Machine.where(:machine_owner_id => current_user.firm)
		@machine_display_name = @machines.find(@event.machine_id).display_name
		@hc = HourCounter.find_by_machine_id(@event.machine_id).machine_hours_age
	end 
	
	def update
		@event = ServiceEvent.find(params[:id])
		@machines = Machine.where(:machine_owner_id => current_user.firm)
		@machine_display_name = @machines.find(@event.machine_id).display_name
		@hc = HourCounter.find_by_machine_id(@event.machine_id)
		@event.service_event_files.build
		respond_to do |format|
			if @event.update_attributes(params[:service_event])
				if params[:alarms] != nil
					# entered alarms difference
					@new_alarms = params[:alarms].map(&:to_i) - @event.alarm_ids
					@event.alarms << Alarm.find(@new_alarms)
					# deleted alarms diference
					@deleted_alarms = @event.alarm_ids - params[:alarms].map(&:to_i)
					@deleted_alarms.each do |obj|
						@event.alarms.delete Alarm.find(obj)
					end
				else
					@event.alarms.delete_all
				end
				if params[:hour_counter].to_i != @hc
					@hc.update_attributes(:machine_hours_age => params[:hour_counter].to_i)
				end
				# @event.unconfirmed
				flash[:notice] = "Successfully updated event."
				format.html { redirect_to service_event_path(@event) }
			else
				flash[:alert] = "Please corect errors and try again"
				redirect_to edit_service_event_path(@event), :method => :get
			end
	    end
	end
	
	def evaluate
		@event = ServiceEvent.find(params[:id])
		@event.service_event_files.build
		@event.alarms.build
	end

	def create_evaluate
		@event = ServiceEvent.find(params[:id])
		@event.evaluator = current_user.id
		if @event.update_attributes(params[:service_event])
			redirect_to service_event_path(@event), notice: "Yeeey, is saved!"
			@event.evaluate
		else
			render :evaluate
			flash.now[:alert] = "error" 
		end
	end
	
	private
	def check_event_confirmation(id)
		@audit_event = ServiceEventStateTransition.where(:service_event_id => id).where(to:['confirmed', 'revised_event'])
		if @audit_event.blank?
			true
		else
			@class = 'disabled'
			@title = 'Event is already confirmed'
			@confirm_event_link ='#'
			@confirm_event_confirmation = nil
		end
	end


	# def delete
	# 	@event = ServiceEvent.find(params[:id])
	# end

	# def destroy
	# 	event = ServiceEvent.find(params[:id]).destroy
	# 	flash[:notice] = "Event permanently deleted !"
	# 	redirect_to(:action => 'list')
	# end

end