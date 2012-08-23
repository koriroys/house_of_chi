require 'spec_helper'
require 'helpers/omniauth_helper'

describe "login" do
  it "auths with facebook" do
    visit root_url
    click_link 'Sign in with Facebook'
    expect(page).to have_content('Signed in as')
  end
end
