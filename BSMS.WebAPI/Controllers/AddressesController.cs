using BSMS.BusinessLayer.Commands;
using BSMS.BusinessLayer.Queries;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BSMS.WebAPI.Controllers
{
    [ApiController]
    [Route("api/customers/[controller]")]
    public class AddressesController : ControllerBase
    {
        private readonly IMediator _mediator;

        public AddressesController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [Authorize(Roles = "admin")]
        [HttpGet]
        public async Task<IActionResult> GetAllAddresses()
        {
            return Ok(await _mediator.Send(new GetAllAddressesQuery()));
        }
        
        [Authorize]
        [HttpGet("{id}")]
        public async Task<IActionResult> GetAddressById(int id)
        {
            return Ok(await _mediator.Send(new GetAddressByIdQuery { AddressId = id }));
        }

        [HttpPost]
        public async Task<IActionResult> AddAddress(CreateAddressCommand command)
        {
            var id = await _mediator.Send(command);

            return CreatedAtAction(nameof(GetAddressById), new { id }, command);
        }

        [Authorize(Roles = "guest")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteAddress(int id)
        {
            return Ok(await _mediator.Send(new DeleteAddressCommand { AddressId = id }));
        }

        [Authorize(Roles = "guest")]
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateAddress(int id, UpdateAddressCommand command)
        {
            command.AddressId = id;

            return Ok(await _mediator.Send(command));
        }
    }
}
