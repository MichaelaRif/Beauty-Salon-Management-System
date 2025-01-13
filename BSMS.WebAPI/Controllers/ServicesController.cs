using BSMS.BusinessLayer.Commands;
using BSMS.BusinessLayer.Queries;
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

    }
}
