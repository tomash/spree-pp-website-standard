Deface::Override.new(:virtual_path => "spree/admin/configurations/index",
                     :name => "add_paypal_preferences_link",
                     :insert_bottom => "[data-hook='configuration']",
                     :text => %q{
                        <tr>
                          <td><%= link_to t(:paypal_preferences), admin_paypal_preferences_path %></td>
                          <td><%= t(:set_paypal_preferences_here) %></td>
                        </tr>
                      },
                     :disabled => false)