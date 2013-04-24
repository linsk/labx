Rails.application.config.middleware.use OmniAuth::Builder do
  provider :identity, fields: [:email, :name], model: User, on_failed_registration: lambda { |env|      
    UsersController.action(:new).call(env)  
  }
  provider :qq, '100686158','12b861c0fff00de11677c3826ff03681'
	provider :github,'d101c632fdbade76b876','ad8d56574fadd87ba79b586edd828644a54d51ca'
	provider :weibo,'796449044','ff171ddc9fb600aaddd56fb70766d209'
end