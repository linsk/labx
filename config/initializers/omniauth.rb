Rails.application.config.middleware.use OmniAuth::Builder do
  provider :identity, fields: [:email, :name], model: User, on_failed_registration: lambda { |env|      
    UsersController.action(:new).call(env)  
  }
  #provider :qq, '100686158','12b861c0fff00de11677c3826ff03681'
	provider :github,'ecd5eb9342a1e009230e','74f32ec34cb593c2bdfa32010c9e8d6e2ece4e10'
	provider :weibo,'2623112401','61073d92914d20bb805efa2c8c8c3233'
end