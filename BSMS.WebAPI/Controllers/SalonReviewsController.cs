using BSMS.BusinessLayer.Queries;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace BSMS.WebAPI.Controllers
{
    [Route("api")]
    [ApiController]
    public class SalonReviewsController : ControllerBase
    {
        private readonly IMediator _mediator;

        public SalonReviewsController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [HttpGet("/top-5/salon-reviews")]
        public async Task<IActionResult> GetTopSalonReview()
        {
            return Ok(await _mediator.Send(new GetTopSalonReviewQuery()));

        }

    }
}
