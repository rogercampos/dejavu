require "spec_helper"

describe "Dejavu" do
  describe "creation" do
    before do
      visit new_product_path
      fill_in "Name", :with => "Mug"
      fill_in "Code", :with => "PT"
      click_button "Create Product"
    end

    it "should redirect me to the new product page after a failed creation" do
      current_path.should == new_product_path
    end

    it "should show the existing errors" do
      page.should have_content("Code is too short")
    end

    it "should have the fields prefilled with the previously entered values" do
      field_should_have "product_name", "Mug"
      field_should_have "product_code", "PT"
    end
  end

  describe "update" do
    before do
      @p = Product.create! :name => "A mug", :code => "PX54"

      visit edit_product_path(@p)
      fill_in "Name", :with => "UA"
      click_button "Update Product"
    end

    it "should redirect me to the edit product page after a failed update" do
      current_path.should == edit_product_path(@p)
    end

    it "should show the existing errors" do
      page.should have_content("Name is too short")
    end

    it "should have the fields prefilled with the previously entered values" do
      field_should_have "product_name", "UA"
      field_should_have "product_code", "PX54"
    end
  end
end
