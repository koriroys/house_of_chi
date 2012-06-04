require 'spec_helper'

describe TracksController do
  describe '#index' do
    it 'gets all the tracks' do
      get :index
      assigns(:tracks).should_not be_empty
    end
  end
end
