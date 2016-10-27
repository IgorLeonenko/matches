<template>
  <div v-if="tournament">
    <h3>Info</h3>
    <p>
      State: {{tournament.state}}
    </p>
    <p>
      Style: {{tournament.style}}
    </p>
    <p>
      Description: {{tournament.description}}
    </p>
    <p>
      Start date: {{tournament.start_date}}
    </p>
    <p>
      Teams slots:
      ({{tournament.teams.length}} / {{tournament.teams_quantity}})
    </p>
  </div>
</template>

<script>
  export default {
    name: 'TournamentInfo',
    props: {
      tournament: {}
    }
  }
</script>
