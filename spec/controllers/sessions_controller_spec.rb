RSpec.describe(SessionsController, type: :controller) do
  include SessionsHelper
  def get_user
    @user = User.find_by(email: 'email4@gmail.com')
    @user ||= User.create!(name: 'thanh',
                           email: 'email4@gmail.com',
                           password: '123456',
                           password_confirmation: '123456')
  end

  before :each do
    @user = get_user
  end
  after :all do
    @user = get_user
    @user.destroy
  end

  context 'GET new' do
    it 'get login page' do
      get :new
      expect(response.status).to render_template(:new)
    end
  end

  context 'POST login' do
    it 'login with valid account' do
      params = { session: { email: 'email4@gmail.com', password: '123456' } }
      post :create, params: params
      expect(response).to redirect_to user_path(@user)
    end

    it 'login with invalid account' do
      params = { session: { email: 'email4@gmail.com', password: '' } }
      post :create, params: params
      expect(response).to render_template(:new)
    end
  end

  context 'logout' do
    it 'logout successfully' do
      log_in(@user)
      delete :destroy
      expect(response).to redirect_to root_path
    end
  end
end