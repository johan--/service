require 'spec_helper'

describe AlarmsController do
  let(:valid_attributes) { { "number" => "1", "text"=> "Alarm text" } }
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all alarms as @alarms" do
      alarm = Alarm.create! valid_attributes
      get :index, {}, valid_session
      assigns(:alarms).should eq([alarm])
    end
  end

  describe "GET show" do
    it "assigns the requested alarm as @alarm" do
      alarm = Alarm.create! valid_attributes
      get :show, {:id => alarm.to_param}, valid_session
      assigns(:alarm).should eq(alarm)
    end
  end

  describe "GET new" do
    it "assigns a new alarm as @alarm" do
      get :new, {}, valid_session
      assigns(:alarm).should be_a_new(Alarm)
    end
  end

  describe "GET edit" do
    it "assigns the requested alarm as @alarm" do
      alarm = Alarm.create! valid_attributes
      get :edit, {:id => alarm.to_param}, valid_session
      assigns(:alarm).should eq(alarm)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Alarm" do
        expect {
          post :create, {:alarm => valid_attributes}, valid_session
        }.to change(Alarm, :count).by(1)
      end

      it "assigns a newly created alarm as @alarm" do
        post :create, {:alarm => valid_attributes}, valid_session
        assigns(:alarm).should be_a(Alarm)
        assigns(:alarm).should be_persisted
      end

      it "redirects to the created alarm" do
        post :create, {:alarm => valid_attributes}, valid_session
        response.should redirect_to(Alarm.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved alarm as @alarm" do
        # Trigger the behavior that occurs when invalid params are submitted
        Alarm.any_instance.stub(:save).and_return(false)
        post :create, {:alarm => { "number" => "invalid value" }}, valid_session
        assigns(:alarm).should be_a_new(Alarm)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Alarm.any_instance.stub(:save).and_return(false)
        post :create, {:alarm => { "number" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested alarm" do
        alarm = Alarm.create! valid_attributes
        # Assuming there are no other alarms in the database, this
        # specifies that the Alarm created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Alarm.any_instance.should_receive(:update_attributes).with({ "number" => "1" })
        put :update, {:id => alarm.to_param, :alarm => { "number" => "1" }}, valid_session
      end

      it "assigns the requested alarm as @alarm" do
        alarm = Alarm.create! valid_attributes
        put :update, {:id => alarm.to_param, :alarm => valid_attributes}, valid_session
        assigns(:alarm).should eq(alarm)
      end

      it "redirects to the alarm" do
        alarm = Alarm.create! valid_attributes
        put :update, {:id => alarm.to_param, :alarm => valid_attributes}, valid_session
        response.should redirect_to(alarm)
      end
    end

    describe "with invalid params" do
      it "assigns the alarm as @alarm" do
        alarm = Alarm.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Alarm.any_instance.stub(:save).and_return(false)
        put :update, {:id => alarm.to_param, :alarm => { "number" => "invalid value" }}, valid_session
        assigns(:alarm).should eq(alarm)
      end

      it "re-renders the 'edit' template" do
        alarm = Alarm.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Alarm.any_instance.stub(:save).and_return(false)
        put :update, {:id => alarm.to_param, :alarm => { "number" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested alarm" do
      alarm = Alarm.create! valid_attributes
      expect {
        delete :destroy, {:id => alarm.to_param}, valid_session
      }.to change(Alarm, :count).by(-1)
    end

    it "redirects to the alarms list" do
      alarm = Alarm.create! valid_attributes
      delete :destroy, {:id => alarm.to_param}, valid_session
      response.should redirect_to(alarms_url)
    end
  end

end
