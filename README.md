Dejavu
======

Dejavu is a very small piece of software which lets you remember your object
state after a failed POST action using redirect. A typical Rails controller
`create` action looks like this:

```
  # POST /products
  # POST /products.json
  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end
```

But this approach has some disadvantadges:

  - Implicitly rendering the view of another action may be difficult if more
    information is needed. If the original 'new' action also loads a
    bunch of `@banners` objects, for instance, we must do it here too. Then we
    have to mantain the same code in two different places or work out some
    sort of DRY solution.

  - It might happen that an exactly "new" view for that model doesn't make
    sense. If it's edited and/or created from different places, for example,
    we have no 'new' to render.

  - Lastly, the url shown is the POST url, which it's very confusing to the
    users since he/she will see the same url as the "index" page (GET) for
    that model. How it's possible that I see two different things for the
    same url? The final user don't understand about that GET/POST stuff.


Usage
=====

If you want to use Dejavu, simply add a `save_for_dejavu` call in the
controller and issue a redirect instead of a render:

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render json: @product, status: :created, location: @product }
      else
        save_for_dejavu @product
        format.html { redirect_to new_product_url }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end

Then, in the view load the object in the form usign the `get_dejavu_for`:

    <%= form_for(get_dejavu_for(@product)) do |f| %>
      <% # Some field ... %>
    <% end %>


Nested Attributes
-----------------

You can also use dejavu to recreate a one-to-one associated model in your
form. To do so you must tell dejavu which association to save in the
controller:

    save_for_dejavu @product, :nested => :prices

This will assume you have a `Product` class which has a `:has_one` association
to a `Price` class.



Final notes
===========

Dejavu uses `flash` to store the previous object state, so when rendering the
flash messages in your layouts make sure to show ONLY the "alert" and "notice"
fields, not everything!
