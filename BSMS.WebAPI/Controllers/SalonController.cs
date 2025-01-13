using BSMS.BusinessLayer.Commands;
using BSMS.BusinessLayer.Queries;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace BSMS.WebAPI.Controllers
{
    [Route("api/salon")]
    [ApiController]
    public class SalonController : ControllerBase
    {
        private readonly IMediator _mediator;

        public SalonController(IMediator mediator)
        {
            _mediator = mediator;
        }

        // GET /api/salon/reviews/top-5
        [HttpGet("reviews/top-5")]
        public async Task<IActionResult> GetTopSalonReview()
        {
            return Ok(await _mediator.Send(new GetTopSalonReviewQuery()));

        }

        // POST /api/salon/reviews/customer
        [HttpPost("reviews/customer")]
        public async Task<IActionResult> AddSalonReviewAsync([FromBody] CreateSalonReviewCommand command)
        {
            var result = await _mediator.Send(command);

            return CreatedAtAction(nameof(GetSalonReviewByIdAsync), new { id = result }, result);
        }

        // GET /api/salon/reviews/customer/salon-review-id
        [ActionName("GetSalonReviewByIdAsync")]
        [HttpGet("reviews/customer/{id}")]
        public async Task<IActionResult> GetSalonReviewByIdAsync(int id)
        {
            var command = new GetSalonReviewByIdQuery
            {
                SalonReviewId = id
            };

            var result = await _mediator.Send(command);

            return Ok(result);
        }

        // DELETE /api/salon/reviews/customer/salon-review-id
        [HttpDelete("reviews/customer/{id}")]
        public async Task<IActionResult> DeleteSalonReviewAsync(int id)
        {
            var command = new DeleteSalonReviewCommand
            {
                SalonReviewId = id
            };
            await _mediator.Send(command);
            return NoContent();
        }

        [HttpPost("contact-us")]
        public async Task<IActionResult> ContactUsAsync([FromBody] CreateContactUsCommand command)
        {
            var result = await _mediator.Send(command);

            return Ok();
        }

    }
}
