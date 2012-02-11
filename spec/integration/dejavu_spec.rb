require "spec_helper"

describe "Dejavu" do
  describe "creation" do
    before do
      visit new_product_path
      fill_in "Name", :with => "Mug"
      fill_in "Code", :with => "PT"
      fill_in "product_category_attributes_name", :with => "Mugs"
      fill_in "product_colors_attributes_0_name", :with => "Blue"
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

    it "should have the many-to-one association prefilled with the previously entered values" do
      field_should_have "product_category_attributes_name", "Mugs"
    end

    it "should have the one-to-many association prefilled with the previously entered values" do
      field_should_have "product_colors_attributes_1_name", "Blue"
    end
  end

  describe "update" do
    before do
      @p = Product.create! :name => "A mug", :code => "PX54", :category => (Category.create! :name => "Mugs")
      Color.create! :name => "Blue", :product => @p

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

    it "should have the many-to-one association prefilled with the previously entered values" do
      field_should_have "product_category_attributes_name", "Mugs"
    end

    it "should have the one-to-many association prefilled with the previously entered values" do
      field_should_have "product_colors_attributes_0_name", "Blue"
    end
  end
end
