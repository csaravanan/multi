require 'spec_helper'

describe 'user authentication' do
	let(:user) { build(:user) }
	let!(:account) { create(:account_with_schema, owner:user)}
	
	it 'allows signin with valid credentials' do
		sign_user_in(user, subdomain: account.subdomain)
		
		expect(page).to have_content('signed in successfully')
	end

	it 'does not allows signin with valid credentials' do
	    sign_user_in(user, subdomain: account.subdomain, password: 'wrong pw')

		expect(page).to have_content('Invalid email or password')
	end

	it 'does not allow user to sign in unless on subdomain' do
		expect { visit new_user_session_path }.to raise_error ActionController::RoutingError
	end
     
     it 'does not allow user from one subdomain to sign in on another subdoamin' do
     	user2 = build(:user)
     	account2 = create(:account_with_schema, owner: user2)

     	sign_user_in(user2,subdomain: account.subdomain)
     	expect(page).to have_content('signed in successfully')

     	sign_user_in(user2,subdomain: account.subdomain)
     	expect(page).to have_content('Invalid email or password')
     end

     it 'allows user to sign out' do
		sign_user_in(user, subdomain: account.subdomain)

        #visit root_path
        click_link 'sign out'
		expect(page).to have_content('signed out successfully')
     end
   end

   def sign_user_in(user, opts={})
   	visit new_user_session_url(subdomain: opts[:subdomain])
   	fill_in 'Email', with: user.email
	fill_in 'Password', with: (opts[:password] || user.password)
	click_button 'Sign in'
end