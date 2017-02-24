require 'rails_helper'

feature 'restaurants' do
  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do
    before do
      Restaurant.create(name: 'KFC')
    end
    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do
    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      expect(current_path).to eq "/users/sign_in"
    end
  end

  context 'viewing restaurants' do
    let!(:kfc){ Restaurant.create(name:'KFC') }
    scenario 'lets a user view a restaurant' do
     visit '/restaurants'
     click_link 'KFC'
     expect(page).to have_content 'KFC'
     expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

  context 'editing restaurants' do
    before { Restaurant.create name: 'KFC', description: 'Deep fried goodness', id: 1 }
    scenario 'let a user edit a restaurant' do
      sign_up
      visit '/restaurants'
      create_restaurant
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      fill_in 'Description', with: 'Deep fried goodness'
      click_button 'Update Restaurant'
      click_link 'Kentucky Fried Chicken'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(page).to have_content 'Deep fried goodness'
    end
  end

  context 'deleting restaurants' do
    before { Restaurant.create name: 'KFC', description: 'Deep fried goodness' }
    scenario 'removes a restaurant when a user clicks a delete link' do
      sign_up
      create_restaurant
      click_link 'Delete KFC'
      expect(page).not_to have_link 'Edit KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end
  end

  context 'create restaurants' do
    before {sign_up}
    scenario 'user should sign up to create restaurant' do
    visit '/restaurants'
    click_link 'Add a restaurant'
    fill_in 'Name', with: 'KFC'
    click_button 'Create Restaurant'
    expect(page).to have_content 'KFC'
    expect(current_path).to eq '/restaurants'
    end
  end

  context 'User sign in into account' do
    scenario 'able to edit and delete restaurants user created'do
      sign_up
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content("Edit KFC")
      expect(page).to have_content("Delete KFC")
    end
  end

   context 'user restriction' do
    scenario 'unable to edit and delete restaurants that a different user created' do
      sign_up
      create_restaurant
      click_link('Sign out')
      sign_up2
      expect(page).not_to have_content("Edit KFC")
      expect(page).not_to have_content("Delete KFC")
    end
  end
end
