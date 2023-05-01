# Little Esty Shop - Bulk Discount
"Bulk Discounts" is a brownfield app which adds functionality to "Little Esty Shop." The latter was a group project that requires Turing students to build a fictitious e-commerce platform where merchants and admins can manage inventory and fulfill customer invoices. Bulk Discounts allowed merchants to create bulk sale discounts which the app would apply when necessary and adjust sale invoices appropriately. 

## Functionality 
<details>
  <summary>CRUD</summary>
  This app allows for full CRUD functionality. 
  <details>
    <summary>CRUD Code Example</summary>
      Here's an overview using the <i>BulkDiscountsController</i>: <br>
      <img src="app/assets/images/crud/BD_CRUD_index,show,create.png">
      <img src="app/assets/images/crud/BD_Crud_edit_to_private.png">
    <ul>
      <li>Notice that: if a user fails to create or edit a discount, they see a flash message and are returned to the create/edit page. The valid values they previously populated will prepopulate in the related fields</li>
    </ul>
  </details>
  <details>
    <summary>UX with CRUD</summary>
      Fields cannot be left blank. Let us see what the user experience is when they try creating a discount with a blank field:
      <img src="app/assets/images/crud/ux/BD_CRUD_create_attempt.png">
      We are returned to the create page, informed that our attempt to create was unsuccessful, but the values we previously entered do persit!
      <img src="app/assets/images/crud/ux/BD_CRUD_create_failed.png">
      Last, once the user fills in the required field the new discount is created, they are returned to the dashboard, and a success message is displayed
      <img src="app/assets/images/crud/ux/BD_CRUD_create_complete.png">
    </details>
</details>

<details>
  <summary>SQL</summary>
  Only 1 discount <i>could</i> apply to each line item on the invoice: <u>the discount most favorable to the customer</u>. A item could qualify for countless discounts but only the most customer-friendly discount mattered. Or, no discount could apply!
  <details>
    <summary>SQL Code Example</summary>

  </details>
</details>

<!-- 
## 'US-6 & US-7:  Total Revenue and Discounted Revenue and Link to Discount' -->