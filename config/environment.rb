# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Blog::Application.initialize!

# loading the RedisDictionary engine
RedisDictionary::Engine.load!