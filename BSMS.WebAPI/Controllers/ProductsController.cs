using BSMS.BusinessLayer.Commands.Create;
using BSMS.BusinessLayer.Commands.Delete;
using BSMS.BusinessLayer.Queries.Get.All;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BSMS.WebAPI.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/products/customer")]
    public class ProductsController : ControllerBase
    {
        private readonly IMediator _mediator;

        public ProductsController(IMediator mediator)
        {
            _mediator = mediator;
        }

        // POST /api/products/customer/favorite
        [HttpPost("favorite")]
        public async Task<IActionResult> AddProductFavoriteAsync([FromBody] CreateProductFavoriteCommand command)
        {
            var result = await _mediator.Send(command);

            return Ok(result);
        }

        // GET /api/products/customer/favorites
        [HttpGet("favorites")]
        public async Task<IActionResult> GetProductFavoritesAsync()
        {
            var query = new GetAllProductFavoritesQuery();
            var result = await _mediator.Send(query);

            return Ok(result);
        }


        // DELETE /api/products/customer/favorite/product-id
        [HttpDelete("favorite/{id}")]
        public async Task<IActionResult> DeleteProductFavoriteAsync(int id)
        {
            var command = new DeleteProductFavoriteCommand
            {
                ProductId = id
            };

            await _mediator.Send(command);

            return Ok();
        }

        // POST /api/products/customer/cart
        [HttpPost("cart")]
        public async Task<IActionResult> AddProductToCartAsync([FromBody] CreateProductCartCommand command)
        {
            var result = await _mediator.Send(command);

            return Ok(result);
        }

        // GET /api/products/customer/carts
        [HttpGet("carts")]
        public async Task<IActionResult> GetProductCartAsync()
        {
            var query = new GetAllProductCartQuery();
            var result = await _mediator.Send(query);

            if (result == null)
            {
                return BadRequest("No products found in cart");
            }

            return Ok(result);
        }


        // DELETE /api/products/customer/cart/product-id
        [HttpDelete("cart/{id}")]
        public async Task<IActionResult> DeleteProductFromCartAsync(int id)
        {
            var command = new DeleteProductCartCommand
            {
                ProductId = id
            };

            await _mediator.Send(command);

            return Ok();
        }

    }
}
