require 'spec_helper'

describe "user profile" do
  let (:auth) { { provider: 'fb', uid: '4444', info: { name: 'kori' } }.as_json }
end
