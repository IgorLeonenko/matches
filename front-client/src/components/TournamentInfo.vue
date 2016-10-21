<template>
  <div v-if='tournament'>
    <h3>Info</h3>
    <p>
      State: {{tournament.state}}
    </p>
    <p>
      Title: {{tournament.title}}
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
      ({{tournament.teams_size}} / {{tournament.teams_quantity}})
    </p>
  </div>
</template>

<script>
  import api from '../api'
  export default {
    name: 'TournamentInfo',
    data () {
      return {
        tournament: null
      }
    },
    mounted () {
      api.getTournament(this.$route.params.id).then(response => {
        this.tournament = response.data
      })
    }
  }
</script>
