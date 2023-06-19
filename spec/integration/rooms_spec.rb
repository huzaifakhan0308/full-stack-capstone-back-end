require 'swagger_helper'

describe 'Rooms API' do
  path '/rooms' do
    get 'Retrieves all rooms' do
      tags 'Rooms'
      produces 'application/json'

      response '200', 'rooms found' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   room_name: { type: :string },
                   description: { type: :string },
                   wifi: { type: :boolean },
                   tv: { type: :boolean },
                   room_service: { type: :boolean },
                   beds: { type: :integer },
                   image_url: { type: :string },
                   address: { type: :string },
                   users_id: { type: :integer }
                 },
                 required: %w[id room_name description wifi tv room_service beds
                              image_url address users_id]
               }

        run_test!
      end
    end

    post 'Creates a room' do
      tags 'Rooms'
      consumes 'application/json'
      parameter name: :room, in: :body, schema: {
        type: :object,
        properties: {
          room_name: { type: :string },
          description: { type: :string },
          wifi: { type: :boolean },
          tv: { type: :boolean },
          room_service: { type: :boolean },
          beds: { type: :integer },
          image_url: { type: :string },
          address: { type: :string },
          users_id: { type: :integer }
        },
        required: %w[room_name description wifi tv room_service beds
                     image_url address users_id]
      }

      response '201', 'room created' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 room_name: { type: :string },
                 description: { type: :string },
                 wifi: { type: :boolean },
                 tv: { type: :boolean },
                 room_service: { type: :boolean },
                 beds: { type: :integer },
                 image_url: { type: :string },
                 address: { type: :string },
                 users_id: { type: :integer }
               },
               required: %w[id room_name description wifi tv room_service beds
                            image_url address users_id]

        let(:room) do
          { room_name: 'Test Room', description: 'This is a test room',
            wifi: true, tv: true, room_service: false, beds: 2,
            image_url: 'https://example.com/room.jpg', address: '123 Main St',
            users_id: 1 }
        end

        run_test!
      end

      response '422', 'invalid request' do
        let(:room) { { room_name: 'Test Room' } }
        run_test!
      end

      response '422', 'user room limit exceeded' do
        let(:room) do
          { room_name: 'Test Room', description: 'This is a test room',
            wifi: true, tv: true, room_service: false, beds: 2,
            image_url: 'https://example.com/room.jpg', address: '123 Main St',
            users_id: 1 }
        end
        before do
          allow(User).to receive(:find).and_return(double('user', rooms_count: 5))
        end
        run_test!
      end

      response '422', 'incorrect password or user not logged in' do
        let(:room) do
          { room_name: 'Test Room', description: 'This is a test room',
            wifi: true, tv: true, room_service: false, beds: 2,
            image_url: 'https://example.com/room.jpg', address: '123 Main St',
            users_id: 1 }
        end
        before do
          allow(User).to receive(:find).and_return(double('user', rooms_count: 0, authenticate: false, login: false))
        end
        run_test!
      end
    end
  end

  path '/rooms/{id}' do
    get 'Retrieves a specific room' do
      tags 'Rooms'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'room found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 room_name: { type: :string },
                 description: { type: :string },
                 wifi: { type: :boolean },
                 tv: { type: :boolean },
                 room_service: { type: :boolean },
                 beds: { type: :integer },
                 image_url: { type: :string },
                 address: { type: :string },
                 users_id: { type: :integer }
               },
               required: %w[id room_name description wifi tv room_service beds
                            image_url address users_id]

        let(:room) do
          Room.create(room_name: 'Test Room', description: 'This is a test room',
                      wifi: true, tv: true, room_service: false, beds: 2,
                      image_url: 'https://example.com/room.jpg', address: '123 Main St',
                      users_id: 1)
        end
        let(:id) { room.id }

        run_test!
      end

      response '404', 'room not found' do
        let(:id) { 'invalid_id' }
        run_test!
      end
    end

    delete 'Deletes a room' do
      tags 'Rooms'
      parameter name: :id, in: :path, type: :integer
      parameter name: :password, in: :query, type: :string

      response '200', 'room deleted' do
        let(:room) do
          Room.create(room_name: 'Test Room', description: 'This is a test room',
                      wifi: true, tv: true, room_service: false, beds: 2,
                      image_url: 'https://example.com/room.jpg', address: '123 Main St',
                      users_id: 1)
        end
        let(:id) { room.id }
        let(:password) { 'password' }

        before do |_example|
          allow(User).to receive(:find).and_return(double('user', authenticate: true, login: true))
        end

        run_test!
      end

      response '401', 'incorrect password or user not logged in' do
        let(:room) do
          Room.create(room_name: 'Test Room', description: 'This is a test room',
                      wifi: true, tv: true, room_service: false, beds: 2,
                      image_url: 'https://example.com/room.jpg', address: '123 Main St',
                      users_id: 1)
        end
        let(:id) { room.id }
        let(:password) { 'invalid_password' }

        before do |_example|
          allow(User).to receive(:find).and_return(double('user', authenticate: false, login: false))
        end

        run_test!
      end

      response '404', 'room not found' do
        let(:id) { 'invalid_id' }
        let(:password) { 'password' }

        before do |_example|
          allow(User).to receive(:find).and_return(double('user', authenticate: true, login: true))
        end

        run_test!
      end
    end
  end
end
