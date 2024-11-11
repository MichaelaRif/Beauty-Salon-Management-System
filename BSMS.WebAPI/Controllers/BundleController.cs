using BSMS.BusinessLayer.Commands;
using BSMS.BusinessLayer.DTOs;
using BSMS.BusinessLayer.Queries;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BSMS.WebAPI.Controllers
{
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
        public async Task<ActionResult<IEnumerable<BundleDto>>> GetAll()
        {
            var result = await _mediator.Send(new GetAllBundlesQuery());
            return Ok(result);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<BundleDto>> GetById(int id)
        {
            var result = await _mediator.Send(new GetBundleByIdQuery { BundleId = id });

            return Ok(result);
        }

        [Authorize(Roles = "admin")]
        [HttpPost]
        public async Task<ActionResult<BundleDto>> Create(CreateBundleCommand command)
        {
            var result = await _mediator.Send(command);

            return Ok(result);
        }

        [Authorize(Roles = "admin")]
        [HttpDelete("{id}")]
        public async Task<ActionResult<bool>> Delete(int id)
        {
            var result = await _mediator.Send(new DeleteBundleCommand { BundleId = id });

            return Ok(true);
        }


        [Authorize(Roles = "admin")]
        [HttpPut("{id}")]
        public async Task<ActionResult<BundleDto>> Update(int id, UpdateBundleCommand command)
        {
            var result = await _mediator.Send(new UpdateBundleWithIdCommand(id, command));

            return Ok(result);

        }
    }
}
