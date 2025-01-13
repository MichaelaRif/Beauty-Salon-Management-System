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

      
    }
}
