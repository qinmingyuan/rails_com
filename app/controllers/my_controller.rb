class MyController < ApplicationController
  before_action :require_login

end unless defined? MyController
