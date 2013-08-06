SampleBlog::Admin.controllers :base do
  get :index, :map => "/" do
    render "base/index"
    #redirect url(:accounts, :index)
  end
end
