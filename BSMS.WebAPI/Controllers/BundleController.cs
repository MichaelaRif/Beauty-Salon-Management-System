using BSMS.BusinessLayer.Commands;
using BSMS.BusinessLayer.Queries;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BSMS.WebAPI.Controllers
{
    [Authorize(Roles = "admin")]
    [ApiController]
    [Route("api/[controller]")]
    public class BundleController : ControllerBase
    {
        private readonly IMediator _mediator;

        public BundleController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [HttpGet]
        public async Task<IActionResult> GetAllBundle()
        {
            return Ok(await _mediator.Send(new GetAllBundlesQuery()));
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetBundleById(int id)
        {
            return Ok(await _mediator.Send(new GetBundleByIdQuery { BundleId = id }));
        }

        [HttpPost]
        public async Task<IActionResult> AddBundle(CreateBundleCommand command)
        {
            var id = await _mediator.Send(command);

            return CreatedAtAction(nameof(GetBundleById), new { id }, command);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteBundle(int id)
        {
            return Ok(await _mediator.Send(new DeleteBundleCommand { BundleId = id }));
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateBundle(int id, UpdateBundleCommand command)
        {
            command.BundleId = id;

            return Ok(await _mediator.Send(command));
        }
    }
}
