Given(/^Im on new tab$/) do
end

When(/^I enter url into url bar$/) do
  visit('/')
end

Then(/^I should see home page$/) do
  page.status_code.should be 200
end
