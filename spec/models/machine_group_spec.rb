require 'spec_helper'

describe MachineGroup do
  it { should have_many(:machines) }
  it { should have_many(:alarms) }
end
