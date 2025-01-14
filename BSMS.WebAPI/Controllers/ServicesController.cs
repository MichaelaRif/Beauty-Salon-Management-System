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
    [Route("api/services/customer")]
    public class ServicesController : ControllerBase
    {
        private readonly IMediator _mediator;

        public ServicesController(IMediator mediator)
        {
            _mediator = mediator;
        }

        // POST /api/services/customer/favorite
        [HttpPost("favorite")]
        public async Task<IActionResult> AddFavoriteAsync([FromBody] CreateServiceFavoriteCommand command)
        {
            var result = await _mediator.Send(command);
            return Ok();
        }

        // GET /api/services/customer/favorites
        [HttpGet("favorites")]
        public async Task<IActionResult> GetFavoritesAsync()
        {
            var query = new GetAllServiceFavoritesQuery();
            var result = await _mediator.Send(query);

            return Ok(result);
        }

        // DELETE /api/services/customer/favorite/service-id
        [HttpDelete("favorite/{id}")]
        public async Task<IActionResult> DeleteFavoriteAsync(int id)
        {
            var command = new DeleteServiceFavoriteCommand
            {
                ServiceId = id
            };

            await _mediator.Send(command);

            return Ok();
        }

        // POST /api/services/customer/cart
        [HttpPost("cart")]
        public async Task<IActionResult> AddServiceToCartAsync([FromBody] CreateServiceCartCommand command)
        {
            var result = await _mediator.Send(command);
            return Ok();
        }

        // GET /api/services/customer/carts
        [HttpGet("carts")]
        public async Task<IActionResult> GetServiceCartAsync()
        {
            var query = new GetAllServiceCartsQuery();
            var result = await _mediator.Send(query);

            return Ok(result);
        }

        // DELETE /api/services/customer/cart/service-id
        [HttpDelete("cart/{id}")]
        public async Task<IActionResult> DeleteServiceFromCartAsync(int id)
        {
            var command = new DeleteServiceCartCommand
            {
                ServiceId = id
            };

            await _mediator.Send(command);

            return Ok();
        }

    }
}
