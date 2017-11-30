RSpec.describe(UsersController, type: :controller) do
  include SessionsHelper
  before :all do
    @user = FactoryBot.create(:user)
  end
  before :each do
    @user.reload
  end
  after :all do
    @user.destroy
  end

  context 'get show' do
    it 'visit show page' do
      get :show, params: { id: @user.id }
      expect(response).to render_template(:show)
    end
  end
  context 'get new' do
    it 'visit registration page' do
      get :new
      expect(response).to render_template(:new)
    end
  end
  context 'register new user' do
    it 'register with valid info' do
      log_out if logged_in?
      params = { user: { name: 'name', email: 'example_email@gmail.com',
                         password: '123456', password_confirmation: '123456' } }
      post :create, params: params
      expect(logged_in?).to eq(true)
      user = User.find_by(email: 'example_email@gmail.com')
      user.destroy if user
    end
    it 'register with invalid info' do
      log_out if logged_in?
      params = { user: { name: 'name', email: 'example_email@gmail.com',
                         password: '123456', password_confirmation: '12345' } }
      post :create, params: params
      expect(response).to render_template(:new)
      expect(logged_in?).to eq(false)
    end
  end
  context 'update user info' do
    it 'can not access this page if not log in' do
      log_out if logged_in?
      get :edit, params: { id: @user.id }
      expect(response).to redirect_to(root_path)
    end
    it 'can not access other\'s edit page' do
      log_out if logged_in?
      user2 = User.create!(name: 'thanh2', email: 'email@emailgoogle.com',
                           password: '123456', password_confirmation: '123456')
      log_in user2
      get :edit, params: { id: @user.id }
      user2.destroy
      expect(response).to redirect_to(root_path)
    end
    it 'access self\'s edit page' do
      log_out if logged_in?
      log_in @user
      get :edit, params: { id: @user.id }
      expect(response).to render_template(:edit)
    end
    it 'update with invalid info' do
      log_out if logged_in?
      log_in @user
      params = { id: @user.id, user: { name: '', email: @user.email } }
      put :update, params: params
      expect(response).to redirect_to(edit_user_path(@user))
    end
    it 'update with valid info' do
      log_out if logged_in?
      log_in @user
      params = { id: @user.id, user: { name: 'new_name', email: @user.email } }
      put :update, params: params
      expect(response).to redirect_to(user_path(@user))
    end
  end
end