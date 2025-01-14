using BSMS.BusinessLayer.Commands.Create;
using BSMS.BusinessLayer.Commands.Delete;
using BSMS.BusinessLayer.Commands.Update;
using BSMS.BusinessLayer.Queries.Get.All;
using BSMS.BusinessLayer.Queries.Get.ById;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BSMS.WebAPI.Controllers
{
    [ApiController]
    [Route("api/bundles")]
    public class BundlesController : ControllerBase
    {
        private readonly IMediator _mediator;

        public BundlesController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [Authorize]
        [HttpGet]
        public async Task<IActionResult> GetAllBundle()
        {
            return Ok(await _mediator.Send(new GetAllBundlesQuery()));
        }

        [Authorize]
        [HttpGet("{id}")]
        public async Task<IActionResult> GetBundleById(int id)
        {
            return Ok(await _mediator.Send(new GetBundleByIdQuery { BundleId = id }));
        }

        [Authorize(Roles = "admin")]
        [HttpPost]
        public async Task<IActionResult> AddBundle(CreateBundleCommand command)
        {
            var id = await _mediator.Send(command);

            return CreatedAtAction(nameof(GetBundleById), new { id }, command);
        }

        [Authorize(Roles = "admin")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteBundle(int id)
        {
            return Ok(await _mediator.Send(new DeleteBundleCommand { BundleId = id }));
        }

        [Authorize(Roles = "admin")]
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateBundle(int id, UpdateBundleCommand command)
        {
            command.BundleId = id;

            return Ok(await _mediator.Send(command));
        }
    }
}
