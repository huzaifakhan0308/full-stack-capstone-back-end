require 'swagger_helper'

describe 'Users API' do
  path '/users' do
    post 'Creates a user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          username: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string }
        },
        required: %w[username password password_confirmation]
      }

      response '201', 'user created' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 username: { type: :string },
                 password_digest: { type: :string },
                 created_at: { type: :string, format: 'date-time' },
                 updated_at: { type: :string, format: 'date-time' }
               },
               required: %w[id username created_at updated_at]

        let(:user) { { username: 'testuser', password: 'password', password_confirmation: 'password' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { { username: 'testuser' } }
        run_test!
      end
    end
  end

  path '/users' do
    get 'Retrieves all user' do
      tags 'Users'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'user found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 username: { type: :string },
                 password_digest: { type: :string },
                 created_at: { type: :string, format: 'date-time' },
                 updated_at: { type: :string, format: 'date-time' }
               },
               required: %w[id username created_at updated_at]

        let(:id) { User.create(username: 'testuser', password: 'password', password_confirmation: 'password').id }
        run_test!
      end

      response '404', 'user not found' do
        let(:id) { 'invalid_id' }
        run_test!
      end
    end
  end

  path '/users/{id}' do
    get 'Retrieves a user' do
      tags 'Users'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'user found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 username: { type: :string },
                 password_digest: { type: :string },
                 created_at: { type: :string, format: 'date-time' },
                 updated_at: { type: :string, format: 'date-time' }
               },
               required: %w[id username created_at updated_at]

        let(:id) { User.create(username: 'testuser', password: 'password', password_confirmation: 'password').id }
        run_test!
      end

      response '404', 'user not found' do
        let(:id) { 'invalid_id' }
        run_test!
      end
    end
  end

  path '/users/{id}' do
    put 'Updates a user' do
      tags 'Users'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          current_password: { type: :string },
          username: { type: :string },
          password: { type: :string }
        },
        required: %w[current_password username password]
      }

      response '200', 'user updated' do
        schema type: :object,
               properties: {
                 message: { type: :string },
                 user_id: { type: :integer },
                 username: { type: :string },
                 password: { type: :string }
               },
               required: %w[message user_id username password]

        let(:user) { User.create(username: 'testuser', password: 'password', password_confirmation: 'password') }
        let(:id) { user.id }
        let(:current_password) { 'password' }
        let(:username) { 'updated_username' }
        let(:password) { 'new_password' }

        before do |example|
          example.metadata[:request] = { user: { current_password: 'password' } }
        end

        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { 'invalid_id' }
        let(:user) { { current_password: 'password' } }
        run_test!
      end

      response '401', 'invalid current password' do
        let(:user) { { current_password: 'wrongpassword' } }
        run_test!
      end
    end
  end

  path '/users/{id}' do
    delete 'Deletes a user' do
      tags 'Users'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '204', 'user deleted' do
        let(:user) { User.create(username: 'testuser', password: 'password', password_confirmation: 'password') }
        let(:id) { user.id }
        let(:password) { 'password' }

        before do |example|
          example.metadata[:request] = { user: { username: 'testuser', password: 'password' } }
        end

        run_test!
      end

      response '401', 'invalid credentials' do
        let(:id) { 'invalid_id' }
        let(:password) { 'wrongpassword' }
        run_test!
      end
    end
  end

  path '/users/login' do
    post 'Logs in a user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          username: { type: :string },
          password: { type: :string }
        },
        required: %w[username password]
      }

      response '200', 'user logged in' do
        schema type: :object,
               properties: {
                 message: { type: :string },
                 user_id: { type: :integer },
                 username: { type: :string },
                 password: { type: :string }
               },
               required: %w[message user_id username password]

        let(:user) { { username: 'testuser', password: 'password' } }
        run_test!
      end

      response '401', 'invalid credentials' do
        let(:user) { { username: 'testuser', password: 'wrongpassword' } }
        run_test!
      end
    end
  end

  path '/users/logout' do
    post 'Logs out a user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          username: { type: :string },
          password: { type: :string }
        },
        required: %w[username password]
      }

      response '200', 'user logged out' do
        schema type: :object,
               properties: {
                 message: { type: :string }
               },
               required: ['message']

        let(:user) { { username: 'testuser', password: 'password' } }
        run_test!
      end

      response '401', 'invalid credentials' do
        let(:user) { { username: 'testuser', password: 'wrongpassword' } }
        run_test!
      end
    end
  end
end
