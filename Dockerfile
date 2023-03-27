# Use Ruby 2.7.4 as the base image
FROM ruby:2.7.4

# Set the working directory
WORKDIR /app

# Copy the Gemfile and Gemfile.lock into the image and install dependencies
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5

# Copy the application code into the image
COPY . .

# Install PostgreSQL and its dependencies
RUN apt-get update -qq && apt-get install -y postgresql-client

# Set the environment variables
ENV RAILS_ENV=production
ENV DATABASE_URL=postgresql://postgres:@db:5432/myapp_production

# Precompile the assets
RUN bundle exec rake assets:precompile

# Expose the port that the application will run on
EXPOSE 3000

# Start the Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
