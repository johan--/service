class AlarmsController < ApplicationController
  
  before_filter :check_auth
  before_filter :check_admin
  
  def index
    @alarms = Alarm.all
    respond_to do |format|
      format.html
      format.json { render json: AlarmJdts.new(view_context) }
    end
  end

  def show
    @alarm = Alarm.find(params[:id])
  end

  def new
    @machine_group = MachineGroup.find(params[:machine_group_id])
    @alarm = @machine_group.alarms.build
  end

  def edit
    @alarm = Alarm.find(params[:id])
  end
  
  def create
    @machine_group = MachineGroup.find(params[:machine_group_id])
    @alarm = @machine_group.alarms.build(params[:alarm])
    respond_to do |format|
      if @alarm.save
        format.html { redirect_to @alarm, notice: 'Alarm was successfully created.' }
        format.json { render json: @alarm, status: :created, location: @alarm }
      else
        format.html { render action: "new" }
        format.json { render json: @alarm.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @alarm = Alarm.find(params[:id])

    respond_to do |format|
      if @alarm.update_attributes(params[:alarm])
        format.html { redirect_to @alarm, notice: 'Alarm was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @alarm.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @alarm = Alarm.find(params[:id])
    @alarm.destroy

    respond_to do |format|
      format.html { redirect_to alarms_url }
      format.json { head :no_content }
    end
  end

  def import
    if Alarm.import(params[:file], params[:machine_group_id])
        flash[:notice] = "Alarms imported"
      else
        flash[:alert] = "No file or invalid file format"
      end
      redirect_to resources_machine_group_path(params[:machine_group_id])
  end
end
