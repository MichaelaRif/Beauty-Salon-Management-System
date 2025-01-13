using BSMS.BusinessLayer.Commands;
using BSMS.BusinessLayer.Queries;
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

    }
}
