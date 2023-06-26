require 'swagger_helper'

RSpec.describe 'Reservations API', type: :request do
  path '/users/{id}/reservations' do
    get 'Retrieves all reservations for a user' do
      tags 'Reservations'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :integer

      response '200', 'reservations found' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   from_date: { type: :string, format: 'date' },
                   to_date: { type: :string, format: 'date' },
                   users_id: { type: :integer },
                   rooms_id: { type: :integer }
                 },
                 required: %w[id from_date to_date users_id rooms_id]
               }

        let(:user) { User.create(username: 'testuser', password: 'password') }
        let!(:reservation1) do
          Reservation.create(from_date: '2023-01-01', to_date: '2023-01-05', users_id: user.id, rooms_id: 1)
        end
        let!(:reservation2) do
          Reservation.create(from_date: '2023-02-01', to_date: '2023-02-05', users_id: user.id, rooms_id: 2)
        end
        let(:user_id) { user.id }

        run_test!
      end

      response '404', 'user not found' do
        let(:user_id) { 'invalid_id' }
        run_test!
      end
    end

    post 'Creates a reservation' do
      tags 'Reservations'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :integer
      parameter name: :reservation, in: :body, schema: {
        type: :object,
        properties: {
          from_date: { type: :string, format: 'date' },
          to_date: { type: :string, format: 'date' },
          users_id: { type: :integer },
          rooms_id: { type: :integer }
        },
        required: %w[from_date to_date users_id rooms_id]
      }
      parameter name: :password, in: :query, type: :string

      response '201', 'reservation created' do
        let(:user) { User.create(username: 'testuser', password: 'password') }
        let(:user_id) { user.id }
        let(:reservation) { { from_date: '2023-01-01', to_date: '2023-01-05', users_id: user.id, rooms_id: 1 } }
        let(:password) { 'password' }

        before do
          allow(User).to receive(:find).and_return(double('user', authenticate: true, login: true))
          allow(Reservation).to receive(:exists?).and_return(false)
        end

        run_test!
      end

      response '422', 'already reserved' do
        let(:user) { User.create(username: 'testuser', password: 'password') }
        let(:user_id) { user.id }
        let(:reservation) { { from_date: '2023-01-01', to_date: '2023-01-05', users_id: user.id, rooms_id: 1 } }
        let(:password) { 'password' }

        before do
          allow(User).to receive(:find).and_return(double('user', authenticate: true, login: true))
          allow(Reservation).to receive(:exists?).and_return(true)
        end

        run_test!
      end

      response '401', 'incorrect password or user not logged in' do
        let(:user) { User.create(username: 'testuser', password: 'password') }
        let(:user_id) { user.id }
        let(:reservation) { { from_date: '2023-01-01', to_date: '2023-01-05', users_id: user.id, rooms_id: 1 } }
        let(:password) { 'invalid_password' }

        before do
          allow(User).to receive(:find).and_return(double('user', authenticate: false, login: false))
          allow(Reservation).to receive(:exists?).and_return(false)
        end

        run_test!
      end
    end
  end

  path '/users/{id}/reservations/{id}' do
    delete 'Deletes a reservation' do
      tags 'Reservations'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :password, in: :query, type: :string

      response '200', 'reservation deleted' do
        let(:reservation) do
          Reservation.create(from_date: '2023-01-01', to_date: '2023-01-05', users_id: 1, rooms_id: 1)
        end
        let(:id) { reservation.id }
        let(:password) { 'password' }

        before do
          allow(User).to receive(:find).and_return(double('user', authenticate: true, login: true))
          allow(Room).to receive(:where).and_return(double('room', update: true))
        end

        run_test!
      end

      response '401', 'incorrect password or user not logged in' do
        let(:reservation) do
          Reservation.create(from_date: '2023-01-01', to_date: '2023-01-05', users_id: 1, rooms_id: 1)
        end
        let(:id) { reservation.id }
        let(:password) { 'invalid_password' }

        before do
          allow(User).to receive(:find).and_return(double('user', authenticate: false, login: false))
          allow(Room).to receive(:where).and_return(double('room', update: true))
        end

        run_test!
      end

      response '404', 'reservation not found' do
        let(:id) { 'invalid_id' }
        let(:password) { 'password' }

        before do
          allow(User).to receive(:find).and_return(double('user', authenticate: true, login: true))
        end

        run_test!
      end
    end
  end
end
