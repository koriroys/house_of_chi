require 'spec_helper'
require 'helpers/omniauth_helper'

describe "authentication" do
  before do
    visit login_path
  end

  it "logs in with facebook" do
    expect(page).to have_content('Signed in as')
    expect(current_path).to eq(root_path)
  end

  it "logs the current user out" do
    click_button 'Sign out'
    expect(page).to have_content('Signed out')
    expect(current_path).to eq(root_path)
  end
end
