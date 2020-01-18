require './config/environment'

# Sinatra middleware, must be placed above all controllers. 
#It will interpret any requests with name="_method" by translating 
#the request to whatever is set by the value attribute.
use Rack::MethodOverride

use UsersController
use StudentsController
use DaycaresController
use TimetablesController

run ApplicationController
