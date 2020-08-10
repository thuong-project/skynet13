require "application_system_test_case"

class ExamplesTest < ApplicationSystemTestCase
  setup do
    @example = examples(:one)
  end

  test "visiting the index" do
    visit examples_url
    assert_selector "h1", text: "Examples"
  end

  test "creating a Example" do
    visit examples_url
    click_on "New Example"

    fill_in "Email", with: @example.email
    fill_in "Name", with: @example.name
    click_on "Create Example"

    assert_text "Example was successfully created"
    click_on "Back"
  end

  test "updating a Example" do
    visit examples_url
    click_on "Edit", match: :first

    fill_in "Email", with: @example.email
    fill_in "Name", with: @example.name
    click_on "Update Example"

    assert_text "Example was successfully updated"
    click_on "Back"
  end

  test "destroying a Example" do
    visit examples_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Example was successfully destroyed"
  end
end
