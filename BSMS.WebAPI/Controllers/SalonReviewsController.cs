using BSMS.BusinessLayer.Commands;
using BSMS.BusinessLayer.Queries;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace BSMS.WebAPI.Controllers
{
    [Route("api/salon-reviews")]
    [ApiController]
    public class SalonReviewsController : ControllerBase
    {
        private readonly IMediator _mediator;

        public SalonReviewsController(IMediator mediator)
        {
            _mediator = mediator;
        }

        // GET /api/salon-reviews/top-5
        [HttpGet("top-5")]
        public async Task<IActionResult> GetTopSalonReview()
        {
            return Ok(await _mediator.Send(new GetTopSalonReviewQuery()));

        }

        // POST /api/salon-reviews/customer
        [HttpPost("customer")]
        public async Task<IActionResult> AddSalonReviewAsync([FromBody] CreateSalonReviewCommand command)
        {
            var result = await _mediator.Send(command);

            return CreatedAtAction(nameof(GetSalonReviewByIdAsync), new { id = result }, result);
        }

        // GET /api/salon-reviews/customer/salon-review-id
        [ActionName("GetSalonReviewByIdAsync")]
        [HttpGet("customer/{id}")]
        public async Task<IActionResult> GetSalonReviewByIdAsync(int id)
        {
            var command = new GetSalonReviewByIdQuery
            {
                SalonReviewId = id
            };

            var result = await _mediator.Send(command);

            return Ok(result);
        }

    }
}
