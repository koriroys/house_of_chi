require 'spec_helper'

describe PlaylistsController do
  describe '#index' do
    it 'keeps you from getting into trouble' do
      expect { get :index }.to raise_error(Koala::Facebook::APIError)
    end
  end
end
