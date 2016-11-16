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
    <button v-if="$route.name !== 'tournamentUpdate'" type='button'
            @click='editTournament($route.params.id)'>
      Edit tournament
    </button>
  </div>
</template>

<script>
  import { router } from '../main'
  export default {
    name: 'TournamentInfo',
    props: {
      tournament: {
        type: Object
      }
    },
    methods: {
      editTournament (id) {
        router.push({name: 'tournamentUpdate', params: {id: id}})
      }
    }
  }
</script>
