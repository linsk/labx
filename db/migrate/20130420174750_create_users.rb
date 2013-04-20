class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :nick
      t.string :email
      t.string :website
      t.string :city
      t.string :slogan
      t.date :jointime
      t.string :qq
      t.string :phonecall
      t.string :weibo
      t.date :birthday
      t.string :constellation
      t.string :twitter
      t.string :weixin
      t.string :github
      t.string :name
      t.string :dribbble
      t.string :avatar
      t.date :graduation
      t.string :role
      t.text :introduce
      
      t.timestamps
    end
  end
end
