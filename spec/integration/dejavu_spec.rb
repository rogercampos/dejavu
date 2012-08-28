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
      @p = Product.create! :virtual => "foo", :name => "A mug", :code => "PX54", :category => (Category.create! :name => "Mugs")
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

  describe "virtual attributes" do
    before do
      visit new_product_path
      fill_in "Name", :with => "Mug"
      fill_in "Code", :with => "PT"
      fill_in "Virtual", :with => "ou"
    end

    it "should be prefilled on errors" do
      click_button "Create Product"
      field_should_have "product_virtual", "ou"
    end

    it "should be prefilled if the virtual attribute is ok but there is an error in the form" do
      fill_in "Virtual", :with => "correct"
      click_button "Create Product"
      field_should_have "product_virtual", "correct"
    end

    it "should show existing errors" do
      click_button "Create Product"
      page.should have_content("Virtual is too short")
    end
  end

  describe "only option" do
    it "should not remember errors on code" do
      visit new_only_name_products_path

      fill_in "Create only: name", :with => "Mug"
      fill_in "Create only: code", :with => "PT"
      click_button "Create only name"

      # Blank error is still there because we don't reset the PT
      page.should have_content("Code can't be blank")
    end

    it "should remember errors on name" do
      visit new_only_name_products_path

      fill_in "Create only: name", :with => "pt"
      fill_in "Create only: code", :with => "PTujarsa"
      click_button "Create only name"

      page.should have_no_content("Name can't be blank")
    end
  end
end
